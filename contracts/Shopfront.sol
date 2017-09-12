pragma solidity ^0.4.11;

import "./Stoppable.sol";

contract Shopfront is Stoppable {

	uint public amount;

	struct Product {
		uint id;
		uint price;
		uint stock;
	}

	address public adminAddress;

	Product[] products;
	mapping(uint => bool) productExists;

	modifier onlyAdministrator() {
		require(msg.sender == adminAddress);
		_;
	}

	function Shopfront(address admin) 
	   payable
	{
		require(admin != 0);
		adminAddress = admin;
		amount = msg.value;
	}

	function changeAdministrator(address newAdmin) 
	   public 
	   onlyOwner
	   returns (bool success)
	{
		 require(newAdmin != 0);
         adminAddress = newAdmin;
         return true;
	}

	function depositFunds() 
	   public
	   payable
	   onlyOwner
	   returns (bool success)
	{
		require(msg.value > 0);
		amount += msg.value;
		return true;
	}

	function withdrawFunds() 
	   public
	   onlyOwner
	   returns (bool success)
	{
		uint oldAmount = amount;
		amount = 0;
		msg.sender.transfer(oldAmount);
		return true;
	}

	function addProduct(uint price, uint stock) 
	   public 
	   onlyAdministrator
	   returns (uint id)
	{
		require(price > 0);
		uint newID = products.length;
		products.push(Product({id: newID, price: price, stock: stock}));
		productExists[newID] = true;

		return newID;	
	}

	function deleteProduct(uint id) 
	   public 
	   onlyAdministrator
	   returns (bool success)
	{
        require(productExists[id]);
        productExists[id] = false;
        return true;
	}
}