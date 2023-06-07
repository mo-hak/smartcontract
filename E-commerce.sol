//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract ECommerce {
    struct Product {
        uint256 price;
        uint128 id;
        uint128 quantity;
        address seller;
        string name; 
    }

    Product[] products;
    uint128 public productCount;

    address payable owner;

    event ProductAdded(uint256 price,uint128 id, uint128 quantity, address seller,string name);
    event ProductPurchased(uint256 price,uint128 id, uint128 quantity, address buyer, string name);
    event CommissionWithdrawn( uint amount,address owner);

    constructor() {
        owner = payable(msg.sender);
    }

    function addProduct(string memory name, uint256 price, uint128 quantity) public {
        require(price > 0, "Price must be greater than zero.");
        require(quantity > 0, "Quantity must be greater than zero.");

        productCount++;
        products.push(Product(price,productCount,quantity, msg.sender, name));

        emit ProductAdded( price,productCount, quantity, msg.sender, name);
    }

     function getAllProduct() public view returns (string[] memory, uint256[] memory) {
        string[] memory productNames = new string[](productCount);
         uint256[] memory productPrices = new uint256[](productCount);

        for (uint256 i = 0; i < productCount;) {
        productNames[i] = products[i].name;
        productPrices[i] = products[i].price;
        unchecked{
            i++;
        }
    }

    return (productNames, productPrices);
}
    function purchaseProduct(uint128 _id, uint128 _quantity) public payable {
        require(_id > 0 && _id <= productCount, "Invalid product ID.");
        require(_quantity > 0, "Quantity must be greater than zero.");

        Product memory product = products[_id-1];
        require(product.quantity >= _quantity, "Insufficient quantity available.");

        uint totalPrice = product.price * _quantity;
        require(msg.value >= totalPrice, "Insufficient funds.");

        products[_id-1].quantity -= _quantity;

        // Calculate and transfer commission to the owner
        uint256 commissionAmount = (msg.value*4) / 100;
        owner.transfer(commissionAmount);

        // Transfer payment to the seller
        payable(product.seller).transfer(msg.value-commissionAmount);

        emit ProductPurchased(product.price,_id, _quantity, msg.sender, product.name);
    }
}
