// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.6.0;

import "./SafeMath.sol";

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {

    using SafeMath for uint256;

    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeApprove: approve failed'
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeTransfer: transfer failed'
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::transferFrom: transferFrom failed'
        );
    }

    // take 2% fee 
    function safeTransferFromWithFee(
        address feeTo,
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        uint256 fee = value.mul(2) / 1000;
        value = value.sub(fee);
        address SKP;
        {

             // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
            (bool success0, bytes memory data0) = token.call(abi.encodeWithSelector(0x23b872dd, from, feeTo, fee));
            require(
                success0 && (data0.length == 0 || abi.decode(data0, (bool))),
                'TransferHelper::transferFrom: transferFrom failed'
            );
        }
        if (token == SKP) {
            address taxTo;
            uint256 tax = value.mul(13) / 100;
            (bool success1, bytes memory data1) = token.call(abi.encodeWithSelector(0x23b872dd, from, taxTo, tax));
            require(
                success1 && (data1.length == 0 || abi.decode(data1, (bool))),
                'TransferHelper::transferFrom: transferFrom failed'
            );
            // // bytes4(keccak256(bytes('takeTax(address,address)')));
            (bool success2, bytes memory data2) = token.call(abi.encodeWithSelector(0x23b872dd, from, to));
            require(
                success2 && (data2.length == 0 || abi.decode(data2, (bool))),
                'Tax::take tax failed'
            );
            value = value.sub(tax);
        }
        {
            // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
            (bool success3, bytes memory data3) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
            require(
                success3 && (data3.length == 0 || abi.decode(data3, (bool))),
                'TransferHelper::transferFrom: transferFrom failed'
            );
        }

        
    }

    function safeTransferETHWithFee(address to, uint256 value) public returns(uint) {
        uint fee = value.mul(2)/ 1000;
        (bool success, ) = to.call{value: fee}(new bytes(0));
        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
        return value.sub(fee);
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
    }
}