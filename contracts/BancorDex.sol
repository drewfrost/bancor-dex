//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import "./IBancorNetwork.sol";

contract MyContract {
    IContractRegistry public contractRegistry =
        IContractRegistry(0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4);
    bytes32 public bancorNetworkName = 0x42616e636f724e6574776f726b; // "BancorNetwork"

    function getBancorNetworkContract() public returns (IBancorNetwork) {
        return IBancorNetwork(contractRegistry.addressOf(bancorNetworkName));
    }

    // path and minReturn generated via SDK
    function tradeWithInputs(
        IERC20[] memory _path,
        uint256 _minReturn,
        uint256 _amount
    ) external payable returns (uint256 returnAmount) {
        IBancorNetwork bancorNetwork = getBancorNetworkContract();
        returnAmount = bancorNetwork.convertByPath.value(msg.value)(
            _path,
            _amount,
            _minReturn,
            0x0,
            0x0,
            0
        );
    }

    // path and minReturn generated on chain
    function trade(
        address _sourceToken,
        address _targetToken,
        uint256 _amount
    ) external payable returns (uint256 returnAmount) {
        IBancorNetwork bancorNetwork = getBancorNetworkContract();
        IERC20[] path = bancorNetwork.conversionPath(
            _sourceToken,
            _targetToken
        );
        uint256 minReturn = bancorNetwork.rateByPath(path, _amount);

        returnAmount = bancorNetwork.convertByPath.value(msg.value)(
            path,
            _amount,
            minReturn,
            0x0,
            0x0,
            0
        );
    }
}
