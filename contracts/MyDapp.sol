pragma solidity >=0.4.21 <0.7.0;

import "./UniswapLiteBase.sol";


contract MyDapp is UniswapLiteBase {
    address constant daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    function getEthPriceInDai() public view returns (uint256 tokenAmount) {
        return _getEthToTokenInput(daiAddress, 1 ether);
    }

    function swapEthToDai() external payable returns (uint256 tokensBought) {
        return _ethToToken(daiAddress, msg.value);
    }
}
