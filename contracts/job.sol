//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

//import Swapper contract
import "./swapper.sol";

library Keep3rV1Library {
    function getReserve(address pair, address reserve) external view returns (uint) {
        (uint _r0, uint _r1,) = IUniswapV2Pair(pair).getReserves();
        if (IUniswapV2Pair(pair).token0() == reserve) {
            return _r0;
        } else if (IUniswapV2Pair(pair).token1() == reserve) {
            return _r1;
        } else {
            return 0;
        }
    }
}


contract Job is Swapper{
    // @params lastRun Counter of the time spent since the last call
    uint256 lastRun;

    // @notice Function that will call to the swap function if 10 minuts have passed since the last call
    function work() public {
       require(workable());
        Swapper.swap();
    }

    // @notice Function which checks that 10 minuts have passed since the last call
    function workable() public returns(bool) {
        require(block.timestamp - lastRun > 10 minutes, 'Need to wait 10 minutes');
        lastRun = block.timestamp;
        return true;
    }
    
}
