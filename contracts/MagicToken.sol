pragma solidity ^0.4.23;

// ----------------------------------------------------------------------------
// 'MEB' 'MagicEightBallToken' token contract
//
// Symbol      : MEBT
// Name        : MagicEightBallToken
// Total supply: Generated from contributions
// Decimals    : 18
//
// Enjoy.
//
// (c) muyouzhi / The MIT Licence.
// ----------------------------------------------------------------------------

// SafeMath
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract Controlled {
    address public controller;
    
    modifier onlyController {
        require(msg.sender == controller); 
        _;
    }
    
    constructor() public { controller = msg.sender;}
    
    // Changes the controller of the contract
    // @param _newController
    function changeController(address _newController) public onlyController {
        controller = _newController;
    }
}

// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// MagicToken, an ERC20 compliance token
contract MagicToken is ERC20Interface, Controlled {
    using SafeMath for uint;

    string public symbol;
    string public name;
    uint8 public decimals;
    uint public totalSupply;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        symbol = "MEBT";
        name = "Magic Eight Ball Token";
        decimals = 18;
        totalSupply = 0;
    }

    // Get balance of `tokenOwner`
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    // Get total supply
    function totalSupply() public view returns (uint supply) {
        return totalSupply;
    }

    // Transfer the token of `amount` to account `to`
    function transfer(address to, uint amount) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[to] = balances[to].add(amount);
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // Token owner can approve for transferFrom()
    // from the token owner's account
    function approve(address spender, uint amount) public returns (bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // Transfer tokens
    function transferFrom(address from, address to, uint amount) public returns (bool success) {
        balances[from] = balances[from].sub(amount);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
        balances[to] = balances[to].add(amount);
        emit Transfer(from, to, amount);
        return true;
    }

    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // No ETH
    function () public payable {
        revert();
    }

    ///////////
    // Generate and destory tokens
    ///////////

    // Generates `amount` tokens and assign them to `receiver`
    // @param receiver address
    // @param amount the quantity of tokens generated
    // @return True if tokens are generated correctly
    function generateTokens(address receiver, uint amount) public onlyController returns (bool) {
        totalSupply.add(amount);
        balances[receiver] = balances[receiver].add(amount);
        emit Transfer(0, receiver, amount);
        return true;
    }

    // Burns `amount` tokens from `owner`
    // @param owner the address that will lose tokens
    // @param amount the quantity of tokens to burn
    // @return True if tokens are burned correctly
    function destroyTokens(address owner, uint amount) public onlyController returns (bool) {
        require(balances[owner] >= amount);
        totalSupply.sub(amount);
        balances[owner] = balances[owner].sub(amount);
        emit Transfer(owner, 0, amount);
        return true;
    }
}
