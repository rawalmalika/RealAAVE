import Nat "mo:base/Nat";
import Product "canister:product";
import Text "mo:base/Text";
import D "mo:base/Debug";
import Float "mo:base/Float";
import Reserve "canister:reserves";


actor user {


    var cycle_token : Nat = 0;
    var icp_token : Nat = 0;
    var aCycle : Nat = 0;
    var aICP : Nat = 0;

    var id : Text = "userID"; //simulate what it will be like for one user
    var icp_to_dollar : Float = 1.0; //this will change for now 1.0 for simplicity
    var cycle_to_dollar : Float = 1.0; //this will change for now 1.0 for simplicity
    var minRatio : Float = 1.1;

    //getter functions
    public func icp_tokenbalance(): async Nat {
        return icp_token;
    };

    public func cycle_tokenbalance(): async Nat {
        return cycle_token;
    };

    public func aICP_balance(): async Nat {
        return aICP;
    };

    public func aCycle_balance(): async Nat {
        return aCycle;
    };

    //used by treasury 
    public func increaseCycles(amount: Nat) : async (Text, Bool){
        cycle_token += amount;
        return ("Success", true);
    };

    //used by treasury
    public func increaseICP(amount: Nat) : async (Text, Bool){
        icp_token += amount;
        return ("Success", true);
    };

    //functions to now transfer tokens with Product canister
    //2 functions (one for depositing/redeem), (one for borrow/repay)

//add userID back in as argument eventually
    public func deposit(token_name : Text, amount : Nat) : async (Text, Bool){
        //for deposit cycle_token
        if((Text.equal(token_name, "cycle_token")) and (amount < cycle_token)){
            cycle_token -= amount; 
            let temp = await Product.increaseCycles(amount);
            let temp1 = await Product.mintaCycles(amount);
            aCycle += amount; //eventually include a fixed interest rate to multiply by
            return ("Success", true);
        };
        //for deposit icp_token
        if((Text.equal(token_name, "icp_token")) and (amount < icp_token)){
            icp_token -= amount;
            let temp = await Product.increaseICP(amount);
            let temp1 = await Product.mintaICP(amount);
            aICP += amount; //eventually include a fixed interest rate to multiply by
            return ("Success", true);
        };
        
        //for redeeming cycle_token
        if((Text.equal(token_name, "aCycle")) and (amount < aCycle)){
            aCycle -= amount;
            let temp = await Product.decreaseCycles(amount);
            let temp1 = await Product.burnaCycles(amount);
            cycle_token += amount; //eventually include a fixed interest rate to multiply by
            return ("Success", true);
        };

        //for redeeming ICP_token
        if((Text.equal(token_name, "aICP")) and (amount < aICP)){
            aICP -= amount;
            let temp = await Product.decreaseICP(amount);
            let temp1 = await Product.burnaICP(amount);
            icp_token += amount; //eventually include a fixed interest rate to multiply by
            return ("Success", true);
        };
        return ("Failure - Something went wrong: check balance of token", false);

      
    };

//function for borrowing and repayment
//add userID back in as argument eventually
    public func borrow(token_name : Text, amount : Nat) : async (Text, Bool){
        //for borrowing cycle_token
        if((Text.equal(token_name, "cycle_token"))){
            //checks if meets collateral ratio
            if(((Float.fromInt(aICP) * icp_to_dollar) / (Float.fromInt(amount) * cycle_to_dollar)) > minRatio){
                cycle_token += amount; 
                //eventually change everything to floats!! ***
                //let temp = await Reserve.lockICP(Float.toInt(minRatio * Float.fromInt(amount) * cycle_to_dollar)); //for now just lock minRatio * amount so just lock up bare minimum to borrow (eventually it will be based off how much you want to borrow and health factor)
                let temp = await Reserve.lockICP(amount * 2); //since don't want to change all to floats just lock up twice the amount
                
                //decrease cycle token balance in product!
                return ("Success", true);
            };
                return ("Failure - Borrow less cycles or Deposit more ICP.", false);
        };

        //for borrowing icp_token
        if((Text.equal(token_name, "icp_token"))){
            //checks if meets collateral ratio
            if(((Float.fromInt(aCycle) * cycle_to_dollar) / (Float.fromInt(amount) * icp_to_dollar)) > minRatio){
                icp_token += amount; 
                //let temp = await Reserve.lockCycles(Float.toInt(minRatio * Float.fromInt(amount) * cycle_to_dollar)); 
                let temp = await Reserve.lockCycles(amount * 2);

                //decrease icp token balance in product!
                return ("Success", true);
            };
            return ("Failure - Borrow less ICP or Deposit more cycles.", false);
        };

        return ("Failure - Something went wrong: check name of token", false);
    };
/*       
        //for repayment of borrowed cycle token
        if((Text.equal(token_name, "aCycle")) and (amount < aCycle)){
            aCycle -= amount;
            let temp = await Product.decreaseCycles(amount);
            let temp1 = await Product.burnaCycles(amount);
            cycle_token += amount; //eventually include a fixed interest rate to multiply by
            return ("Success", true);
        };

        //for repayment of borrowed ICP_token
        if((Text.equal(token_name, "aICP")) and (amount < aICP)){
            aICP -= amount;
            let temp = await Product.decreaseICP(amount);
            let temp1 = await Product.burnaICP(amount);
            icp_token += amount; //eventually include a fixed interest rate to multiply by
            return ("Success", true);
        };
        return ("Failure - Something went wrong: check balance of token", false);

      
    };
*/

    //transfers from user to product canister
    //dfx canister call user transfer "(func \"$(dfx canister id product)\".\"wallet_receive\", 5000000)"
};
