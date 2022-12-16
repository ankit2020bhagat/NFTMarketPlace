// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketPlace{

     struct ListNFT{
        uint price;
        address seller;
     }

     event ItemList (
         address indexed seller,
         address indexed nftAddress,
         uint indexed token_id,
         uint price
     );

     event ItemBought (
         address indexed buyer,
         address indexed nftAddress,
         uint indexed token_id,
         uint price
     );

     mapping (address => mapping (uint => ListNFT)) nftholder;

       mapping(address => uint256) private SellerBalance;

       modifier notListed(
        address nftAddress,
        uint256 tokenId
    ) {
        ListNFT memory listing = nftholder[nftAddress][tokenId];
        if (listing.price > 0) {
            revert AlreadyListed(nftAddress, tokenId);
        }
        _;
    }

     modifier isListed(address nftAddress, uint256 tokenId) {
        ListNFT memory listing = nftholder[nftAddress][tokenId];
        if (listing.price <= 0) {
            revert NotListed(nftAddress, tokenId);
        }
        _;
    }

     modifier isOwner(
        address nftAddress,
        uint256 tokenId,
        address spender
    ) {
        IERC721 nft = IERC721(nftAddress);
        address owner = nft.ownerOf(tokenId);
        if (spender != owner) {
            revert NotOwner();
        }
        _;
    }
    ///already listed
    error AlreadyListed(address nftAddress, uint256 tokenId);

    ///not listed
    error NotListed(address nftAddress, uint256 tokenId);
    ///pnly owner can call 
    error NotOwner();

    ///price must be greater than zero
    error PriceMustBeAboveZero();

    ///not approve for market place
    error NotApprovedForMarketplace();

    error PriceNotMet(address nftAddress, uint256 tokenId, uint256 price);

    error NoProceeds();

    function listnft(
        address nftAddress,
        uint256 tokenId,
        uint256 price
    )
        external
        notListed(nftAddress, tokenId)
        isOwner(nftAddress, tokenId, msg.sender)
    {
        if (price <= 0) {
            revert PriceMustBeAboveZero();
        }
        IERC721 nft = IERC721(nftAddress);
        if (nft.getApproved(tokenId) != address(this)) {
            revert NotApprovedForMarketplace();
        }
        nftholder[nftAddress][tokenId] = ListNFT(price, msg.sender);
        emit ItemList(msg.sender, nftAddress, tokenId, price);
    }

     function buyItem(address nftAddress, uint256 tokenId)
        external
        payable
        isListed(nftAddress, tokenId)
        
        
    {
       
        ListNFT memory listedItem = nftholder[nftAddress][tokenId];
        if (msg.value < listedItem.price) {
            revert PriceNotMet(nftAddress, tokenId, listedItem.price);
        }
        SellerBalance[listedItem.seller] += msg.value;
       
        delete (nftholder[nftAddress][tokenId]);
        IERC721(nftAddress).safeTransferFrom(listedItem.seller, msg.sender, tokenId);
        emit ItemBought(msg.sender, nftAddress, tokenId, listedItem.price);
    }

    function updateListing(
        address nftAddress,
        uint256 tokenId,
        uint256 newPrice
    )
        external
        isListed(nftAddress, tokenId)
       
        isOwner(nftAddress, tokenId, msg.sender)
    {
       
        if (newPrice <= 0) {
            revert PriceMustBeAboveZero();
        }
        nftholder[nftAddress][tokenId].price = newPrice;
        emit ItemList(msg.sender, nftAddress, tokenId, newPrice);
    }

    function withdrawProceeds() external {
        uint256 proceeds = SellerBalance[msg.sender];
        if (proceeds <= 0) {
            revert NoProceeds();
        }
        SellerBalance[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: proceeds}("");
        require(success, "Transfer failed");
    }

    function getListing(address nftAddress, uint256 tokenId)
        external
        view
        returns (ListNFT memory)
    {
        return nftholder[nftAddress][tokenId];
    }

    function getProceeds(address seller) external view returns (uint256) {
        return SellerBalance[seller];
    }


}