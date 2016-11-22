
pragma solidity ^0.4.0;


library StringAsKey {
  function convert(string key) returns (bytes32 ret) {
    if (bytes(key).length > 32) {
      throw;
    }

    assembly {
      ret := mload(add(key, 32))
    }
  }
}


contract mortal{

    address public owner;

    function mortal(){

        owner = msg.sender;

    }

    modifier onlyOwner{
        if (msg.sender != owner){
            throw;
        }else{
            _;
        }
    }

    function kill() onlyOwner{

        suicide(owner);
    }
}


contract CarInfo is mortal{

    // string public vin;
    // unit public mileage;
    string public carName;


    struct CarDetails {
        string vin;
        string make;
        string model;
        string color;
        string previousOwner;
        uint  year;
        uint mileage;
    }
    mapping(string=>CarDetails) carDetails;

    function CarInfo(string _name){
        carName = _name;
        // mileage = _mileage
    }

    function registerCar(string _vin, string make, string model, string color, string previousOwner, uint year, uint mileage) onlyOwner {

        carDetails[_vin] = CarDetails({
            vin: _vin,
            make: make,
            model: model,
            color: color,
            previousOwner: previousOwner,
            year: year,
            mileage: mileage
        });

    }

    function getCarDetails(string _vin) {
        if(!msg.sender.send(carDetails[_vin].mileage)) {
            throw;
        }
    }


    function setCarDetails(string _vin, uint _mileage){
        if(carDetails[_vin].mileage < _mileage){
            carDetails[_vin].mileage = _mileage;
            if(!msg.sender.send(carDetails[_vin].mileage)) {
                throw;
            }else{
                throw;
            }
        }
    }

    //function payToProvider(address _providerAddress){
    //  _providerAddress.send(services[_providerAddress].debt);

    //}


    //function unsubscribe(address _providerAddress){
    //  if(services[_providerAddress].debt == 0){
    //      services[_providerAddress].active = false;

    //      }else{
    //          throw;
    //      }
    //}


}

contract Car is mortal{

    string public vin;

    function Car(string _vin){
        vin = _vin;
    }

    function registerCar(string _vin, string make, string model, string color, string previousOwner, uint year, uint mileage, address _userAddress){
        CarInfo carInfo = CarInfo(_userAddress);
        carInfo.registerCar(_vin, make, model, color, previousOwner, year, mileage);

    }

    function getCarDetails(string _vin, address _userAddress){
        CarInfo carInfo = CarInfo(_userAddress);
        carInfo.getCarDetails(_vin);

    }

    function setCarDetails(string _vin, uint _mileage, address _userAddress){

        CarInfo carInfo = CarInfo(_userAddress);
        carInfo.setCarDetails(_vin, _mileage);

    }
}
