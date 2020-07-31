// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "@studydefi/money-legos/uniswap/contracts/IUniswapExchange.sol";
import "@studydefi/money-legos/uniswap/contracts/IUniswapFactory.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract UniswapLiteBase {
    // Uniswap Mainnet factory address
    address constant UniswapFactoryAddress = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;

    function _getUniswapExchange(address tokenAddress)
        internal
        view
        returns (address exchange)
    {
        return IUniswapFactory(UniswapFactoryAddress).getExchange(tokenAddress);
    }

    function _ethToToken(address tokenAddress, uint256 ethAmount)
        internal
        returns (uint256 tokensBought)
    {
        return _ethToToken(tokenAddress, ethAmount, uint256(1));
    }

    function _ethToToken(
        address tokenAddress,
        uint256 ethAmount,
        uint256 minTokenAmount
    ) internal returns (uint256 tokensBought) {
        return
            IUniswapExchange(_getUniswapExchange(tokenAddress))
                .ethToTokenSwapInput
                .value(ethAmount)(minTokenAmount, uint256(now + 60));
    }

    function _tokenToEth(address tokenAddress, uint256 tokenAmount)
        internal
        returns (uint256 ethBought)
    {
        return _tokenToEth(tokenAddress, tokenAmount, uint256(1));
    }

    function _tokenToEth(
        address tokenAddress,
        uint256 tokenAmount,
        uint256 minEthAmount
    ) internal returns (uint256 ethBought) {
        address exchange = _getUniswapExchange(tokenAddress);

        IERC20(tokenAddress).approve(exchange, tokenAmount);

        return
            IUniswapExchange(exchange).tokenToEthSwapInput(
                tokenAmount,
                minEthAmount,
                uint256(now + 60)
            );
    }

    function _tokenToToken(
        address from,
        address to,
        uint256 tokenInAmount,
        uint256 minTokenOut
    ) internal returns (uint256 tokenOutAmount) {
        uint256 ethAmount = _tokenToEth(from, tokenInAmount);
        return _ethToToken(to, ethAmount, minTokenOut);
    }

    function _tokenToToken(address from, address to, uint256 tokenAmount)
        internal
        returns (uint256 tokenOutAmount)
    {
        return _tokenToToken(from, to, tokenAmount, uint256(1));
    }

    function _getTokenToEthInput(address tokenAddress, uint256 tokenAmount)
        internal
        view
        returns (uint256 ethBought)
    {
        return
            IUniswapExchange(_getUniswapExchange(tokenAddress))
                .getTokenToEthInputPrice(tokenAmount);
    }

    function _getEthToTokenInput(address tokenAddress, uint256 ethAmount)
        internal
        view
        returns (uint256 tokensBought)
    {
        return
            IUniswapExchange(_getUniswapExchange(tokenAddress))
                .getEthToTokenInputPrice(ethAmount);
    }

    function _getTokenToEthOutput(address tokenAddress, uint256 ethAmount)
        internal
        view
        returns (uint256 tokensSold)
    {
        return
            IUniswapExchange(_getUniswapExchange(tokenAddress))
                .getTokenToEthOutputPrice(ethAmount);
    }

    function _getEthToTokenOutput(address tokenAddress, uint256 tokenAmount)
        internal
        view
        returns (uint256 ethSold)
    {
        return
            IUniswapExchange(_getUniswapExchange(tokenAddress))
                .getEthToTokenOutputPrice(tokenAmount);
    }

    function _getTokenToTokenInput(address from, address to, uint256 fromAmount)
        internal
        view
        returns (uint256 tokensBought)
    {
        uint256 ethAmount = _getTokenToEthInput(from, fromAmount);
        return _getEthToTokenInput(to, ethAmount);
    }
}
