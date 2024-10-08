// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0<0.8.20;

interface IWETH {

    function deposit() external;

    function withdraw(uint wad) external;

    function totalSupply() external view returns (uint);

    function approve(address guy, uint wad) external returns (bool);

    function transfer(address dst, uint wad) external returns (bool);

    function transferFrom(address src, address dst, uint wad)external returns (bool);

}