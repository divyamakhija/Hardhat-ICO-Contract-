// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract ICOContract {
    address public owner;
    address public tokenAddress;  // Address of the ERC20 token being sold
    uint256 public tokenPrice;    // Price of 1 token in wei (for ETH) or USDT (scaled to 18 decimal places)
    uint256 public tokensSold;
    bool public ICOActive;

    mapping(address => uint256) public balances;

    event TokensPurchased(address indexed buyer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier isICOActive() {
        require(ICOActive, "ICO is not active");
        _;
    }

    constructor(address _tokenAddress, uint256 _tokenPrice) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
        tokenPrice = _tokenPrice;
        ICOActive = true;
    }

    function purchaseTokensWithETH() external payable isICOActive {
        uint256 tokenAmount = msg.value * 1e18 / tokenPrice; // Calculate token amount
        require(tokenAmount > 0, "Insufficient ETH sent");

        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(msg.sender, tokenAmount), "Token transfer failed");

        tokensSold += tokenAmount;
        balances[msg.sender] += tokenAmount;

        emit TokensPurchased(msg.sender, tokenAmount);
    }

    function purchaseTokensWithUSDT(uint256 usdtAmount) external isICOActive {
        IERC20 usdtToken = IERC20(tokenAddress);
        require(usdtToken.transferFrom(msg.sender, address(this), usdtAmount), "USDT transfer failed");

        uint256 tokenAmount = usdtAmount * 1e18 / tokenPrice; // Calculate token amount

        require(tokenAmount > 0, "Insufficient USDT sent");

        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(msg.sender, tokenAmount), "Token transfer failed");

        tokensSold += tokenAmount;
        balances[msg.sender] += tokenAmount;

        emit TokensPurchased(msg.sender, tokenAmount);
    }

    function endICO() external onlyOwner {
        ICOActive = false;
    }

    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
