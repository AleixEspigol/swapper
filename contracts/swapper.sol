//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

//Import UniswapV2 libraries
interface IUniswapV2Router {
  function getAmountsOut(uint256 amountIn, address[] memory path)
    external
    view
    returns (uint256[] memory amounts);
  
  function swapExactTokensForTokens(
  
    //amount of tokens we are sending in
    uint256 amountIn,
    //the minimum amount of tokens we want out of the trade
    uint256 amountOutMin,
    //list of token addresses we are going to trade in.  this is necessary to calculate amounts
    address[] calldata path,
    //this is the address we are going to send the output tokens to
    address to,
    //the last time that the trade is valid for
    uint256 deadline
  ) external returns (uint256[] memory amounts);
  function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        virtual
        override
        payable
        returns (uint[] memory amounts);
}

interface IUniswapV2Pair {
  function token0() external view returns (address);
  function token1() external view returns (address);
  function swap(
    uint256 amount0Out,
    uint256 amount1Out,
    address to,
    bytes calldata data
  ) external;
}

interface IUniswapV2Factory {
  function getPair(address token0, address token1) external returns (address);
}


//import the ERC20 interface for tokens with ERC-20 standard
interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Swapper {
    IERC20 public fromToken;
    IERC20 public toToken;
    uint256 public amountIn;

    //address of the uniswap v2 router
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    
    //address of WETH token.  This is needed because some times it is better to trade through WETH.  
    //you might get a better price using WETH.  
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6b175474e89094c44da98b954eedeac495271d0f;


    // @notice Constructor that allows to initialize the addresses of the 2 tokens that are wanted to interchange
    // @param _fromToken Token that you want to exchange
    // @param _toToken Token what you want to get for the exchange
    constructor(address _fromToken, address _toToken) {
        fromToken = IERC20(_fromToken);
        toToken = IERC20(_toToken);
    }
    /*
    //Version code (ex 1.1)

    // @notice Function that will take the amount of the fromToken from the function caller.
    // @param _amount Amount of fromToken from the function caller
    function provide(uint32 _amount) public {
        require(fromToken.allowance(msg.sender, address(this)) >= _amount, "FromToken allowance too low");
        fromToken.approve(address(this), _amount);
        fromToken.transferFrom(msg.sender, address(this), _amount);
        amountIn = _amount;
    }

    // @notice Function that will exchange all provided tokens into the toToken
    function swap() public {
      address[] memory path = new address[](2);
      path[0] = fromToken;
      path[1] = toToken;
    }

    // @notice Function that allows the user that provided the tokens to withdraw the toTokens that he should be allowed to withdraw
    function withdraw() public { 
        require(toToken.allowance(address(this), msg.sender) >= amountIn, "ToToken allowance too low");
        toToken.approve(msg.sender, amountIn);
        toToken.transferFrom(address(this), msg.sender, amountIn);
    }
    */
    //Version code (ex 1.2)
    
    // @notice Function that will do all the process to exchange to fromToken to toToken using UniswapV2
    function swap() external {
        require(IERC20(DAI).transferFrom(msg.sender, address(this), amountIn), 'Transfer from failed');
        require(IERC20(DAI).approve(UNISWAP_V2_ROUTER, amountIn), 'Approve failed');

        address[] memory path = new address[](2);
        path[0] = address(DAI);
        path[1] = WETH;
        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForETH(amountIn, 0, path, msg.sender, block.timestamp);
    }
}
