// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract ERC20Test is Test {
    /// @dev Address of the SimpleStore contract.
    IERC20Metadata public erc20;

    string public constant name = "Token";
    string public constant symbol = "TOK";
    uint8 public constant decimals = 18;

    /// @dev Setup the testing environment.
    function setUp() public {
        bytes memory args = abi.encode(name, symbol, decimals, address(this));
        erc20 = IERC20Metadata(HuffDeployer.deploy_with_args("ERC20", args));
    }

    function testViewsAfterConstructor() public {
        assertEq(erc20.name(), name);
        assertEq(erc20.symbol(), symbol);
        assertEq(erc20.decimals(), decimals);
        assertEq(erc20.totalSupply(), 0);
        assertEq(erc20.minter(), address(this));
    }

    function testMint() public {
        uint256 amount = 100;
        erc20.mint(address(this), amount);
        assertEq(erc20.balanceOf(address(this)), amount);
        assertEq(erc20.totalSupply(), amount);
        
        // make sure non minters cannot call mint
        vm.prank(vm.addr(1));
        vm.expectRevert();
        erc20.mint(address(this), amount);

        // test overflow
        vm.expectRevert();
        erc20.mint(address(this), type(uint256).max - amount + 1);
    }

    function testApprove() public {
        assertTrue(erc20.approve(address(0xBEEF), 1e18));
        assertEq(erc20.allowance(address(this), address(0xBEEF)), 1e18);
    }
}














/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    function mint(address to, uint256 amount) external returns (bool);
    function minter() external returns (address);
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}