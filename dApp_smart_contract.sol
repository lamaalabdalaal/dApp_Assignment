pragma solidity ^0.8.0;




contract BankofFinTech {
    
    struct KYCRecord {
        
        uint customer_id;
        string full_name;
        string profession;
        string date_of_birth;
        address wallet_addr; 
    }   
     
    

    uint number_of_accounts;
    
    mapping(address=>uint) account_balances;

    mapping(address=>uint) customer_registered_map;

    

    KYCRecord[] public kycRecords;

    function register_account(
             string memory customer_id_, 
             string memory full_name_,
             string memory profession_ ,
             string memory date_of_birth_) public returns (bool) {

        require(customer_registered_map[msg.sender] < 1, "Account already exists!");

        number_of_accounts += 1;   

        kycRecords.push(
             KYCRecord({customer_id: number_of_accounts, 
             full_name:full_name_,
             profession:profession_,
             date_of_birth:date_of_birth_, 
             wallet_addr:msg.sender
             }));

        customer_registered_map[msg.sender] = number_of_accounts;

        return true;
    }

    function get_record(uint rec) private returns (KYCRecord memory)
    {
        return kycRecords[rec-1];

    }


    function get_balance() public view returns (uint) {
        return account_balances[msg.sender];
    }

    

    modifier onlyRegisterd() {
        require( customer_registered_map[msg.sender]>0 , "Account must be registered to use this function");
        _;
    }



    function get_account_info() public onlyRegisterd  view returns (KYCRecord memory) {
        
        return kycRecords[customer_registered_map[msg.sender]-1];
    }

    
    function transfer(address acct_to_transfer_to, uint amount) public onlyRegisterd returns (bool)  {

        require(account_balances[msg.sender]>amount, "Insufficent Funds!");
        account_balances[msg.sender] -= amount;
        account_balances[acct_to_transfer_to] += amount;
        return true;
    } 


    function withdrawl(uint amount) public onlyRegisterd returns (bool){
        
        require(account_balances[msg.sender]>=amount, "Insufficent Funds!");
        account_balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        return true;
    }

    

    receive () external payable {
        account_balances[msg.sender] += msg.value;
    }
}
