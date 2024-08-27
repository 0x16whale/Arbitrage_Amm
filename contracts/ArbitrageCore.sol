// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0<0.8.20;

//uniswap
import "../interfaces/uniswap/IV2SwapRouter.sol";
import "../interfaces/uniswap/IV3SwapRouter.sol";

//sushiswap
import "../interfaces/sushi/ISushiSwapRouter.sol";

//pancakeswap
import "../interfaces/pancake/IPancakeSwapRouterV3.sol";

//
import "../interfaces/IWETH.sol";
import "../interfaces/IERC20.sol";
import "../libraries/uniswap/UniswapLibrary.sol";
import "./ReentrancyGuard.sol";
import "./Ownable.sol";

contract ArbitrageCore is Ownable, ReentrancyGuard{

    uint256 private lockState;

    event withdrawEvent(address indexed token,uint256 indexed amount);

    mapping(address=>address[])private routerToTokens;

    struct userDepositeInfo{
        address user;
        address token;
        uint256 value;
    }

    mapping(address=>userDepositeInfo)private _userDepositeInfo;

    modifier lock(){
        require(lockState==0,"Already lock");
        _;
    }

    function changeLock(uint256 _lockState)external onlyOwner{
        lockState=_lockState;
    }

    function deposite(address _token,uint256 _amount)external payable lock nonReentrant{
        if(_token==address(0)){
            require(msg.value==_amount,"deposite eth amount error");
        }else{
            IERC20(_token).transferFrom(msg.sender,address(this),_amount);
        }

        if(_userDepositeInfo[_token].user!=address(0)){
            _userDepositeInfo[_token].value+=_amount;
        }else{
            _userDepositeInfo[_token]=userDepositeInfo(
                {
                    user: msg.sender,
                    token: _token,
                    value: _amount
                }
            );
        }

    }

    //arbitrage
    

    function getaaa()external view returns(address){
        return address(0);
    }

    function addRouterTokens(address _router,address[] calldata _tokens)external onlyOwner{
        routerToTokens[_router]=_tokens;
    }

    function removeRouterTokens(address _router)external onlyOwner{
        delete routerToTokens[_router];
    }

    //withdraw token
    function withdraw(address _token,uint256 _amount)external onlyOwner{
        if(_token==address(0)){
            uint256 ethBalance=address(this).balance;
            require(ethBalance>=_amount,"Overflow");
            (bool success,)=msg.sender.call{value: _amount}("");
            require(success,"Withdraw eth fail");
        }else{
            uint256 ERC20balance=IERC20(_token).balanceOf(address(this));
            require(ERC20balance>=_amount,"Overflow");
            IERC20(_token).transfer(msg.sender,_amount);
        }
        emit withdrawEvent(_token,_amount);
    }

    function getUserDepositeInfo(address _token)external view returns(userDepositeInfo memory){
        return _userDepositeInfo[_token];
    }

    
}