// SPDX-License-Identifier: GpL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Contract{
    struct Property{
        uint256 price;
        address owner;
        bool ForSale;

        //About the property
        string Property_Name;
        string Property_Address;
        string Property_Desc;
    }

    //Now we need to map the property ids to property in order to track them
    mapping(uint256 => Property) public properties;

    //create an array of all listed properties
    uint256[] public propertyIds;

    //when a property is sold
    event property_sold(uint256 propertyId);

    //To list properties for sale
    function property_forsale(uint256 _propertyId, uint256 _price, string memory _Property_Name, string memory _Property_Address, string memory _Property_Desc) public{

        //store new field for a property in the array
        Property memory newProperty = Property({
            price: _price,
            owner: msg.sender,
            ForSale: true,
            Property_Name: _Property_Name,
            Property_Address : _Property_Address,
            Property_Desc: _Property_Desc

        });

        //push the property to array
        properties[_propertyId] = newProperty;
        propertyIds.push(_propertyId);
    }

    //To buy a property
    function property_tobuy(uint256 _propertyId) public payable{

        //to get struct using mapping
        Property storage property = properties[_propertyId];

        //check if property is up for sale
        require(property.ForSale, "Property is not up for sale !!!");

        //check if the funds offered are sufficient
        require(property.price <= msg.value, "Insufficient funds are being offered !!!");

        //If the funds are sufficient we transfer the property
        property.owner = msg.sender;
        property.ForSale = false;

        //purchase price is sent to the seller
        payable(property.owner).transfer(property.price);

        //execute property sold event
        emit property_sold(_propertyId);
    }
}