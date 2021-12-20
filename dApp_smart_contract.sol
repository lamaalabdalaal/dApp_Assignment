pragma solidity ^0.8.0;



contract BankofFinTech {
    
    struct KYCRecord {
        
        uint customer_id;
        string full_name;
        string profession;
        string date_of_birth;
        address wallet_addr; 
    }   
     
    

    uint number_of_accounts = 0;
    
    mapping(address=>uint) account_balances;

    mapping(address=>uint) customer_registered_map;

    

    KYCRecord[] public KYCRecords;

    function register_account(string memory full_name, string memory customer_id,string memory profession ,string memory date_of_birth) public returns (bool) {

        require(customer_registered_map[msg.sender] < 1, "Account already exists!");

        number_of_accounts += 1;   

        KYCRecords.push(
            KYCRecord({customer_id: number_of_accounts, full_name:full_name,
            profession:profession, date_of_birth:date_of_birth, wallet_addr:msg.sender}));

        customer_registered_map[msg.sender] = number_of_accounts;

        return true;
    }

    function get_record(uint rec) private returns (KYCRecord memory)
    {
        return KYCRecords[rec-1];

    }


    function get_balance() public view returns (uint) {
        return address(this).balance;
    }

    

    modifier onlyRegisterd() {
        require( customer_registered_map[msg.sender]>0 , "Account must be registered to use this function");
        _;
    }



    function get_account_info() public onlyRegisterd  view returns (KYCRecord memory) {
        
        return KYCRecords[customer_registered_map[msg.sender]-1];
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
