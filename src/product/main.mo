

//checking if commiting to git is working --malika 

import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Reserve "canister:reserves";


actor product{

//only keeps track of aCycle and aICP... token_outstanding put in reserves canister
    var aCycle_outstanding : Nat = 0; //product balance of acycles created
    var aICP_outstanding : Nat = 0;
    

//getter functions
    public func icp_tokenbalance(): async Nat {
        let icp_token_outstanding = await Reserve.icp_balance();
        return icp_token_outstanding;
    };

    public func cycle_tokenbalance(): async Nat {
        let cycle_token_outstanding = await Reserve.cycles_balance();
        return cycle_token_outstanding;
    };

    public func aICP_balance(): async Nat {
        return aICP_outstanding;
    };

    public func aCycle_balance(): async Nat {
        return aCycle_outstanding;
    };

//increase/decrease cycles and ICP
    //when user deposits cycles to product
    public func increaseCycles(amount: Nat) : async (Text, Bool){
        //cycle_token_outstanding += amount;
        let temp = await Reserve.increaseAvailCycles(amount);
        return ("Success", true);
    };

    //when user deposits icp to product
    public func increaseICP(amount: Nat) : async (Text, Bool){
        //icp_token_outstanding += amount;
        let temp = await Reserve.increaseAvailICP(amount);
        return ("Success", true);
    };

    //when user redeems cycles from product
    public func decreaseCycles(amount: Nat) : async (Text, Bool){
        //cycle_token_outstanding -= amount;
        let temp = await Reserve.decreaseAvailCycles(amount);
        return ("Success", true);
    };

    //when user redeems icp from product
    public func decreaseICP(amount: Nat) : async (Text, Bool){
        //icp_token_outstanding -= amount;
        let temp = await Reserve.decreaseAvailICP(amount);
        return ("Success", true);
    };

//minting
    //when user deposits cycles to product
    public func mintaCycles (amount : Nat) : async (Text, Bool){
        aCycle_outstanding += amount;
        return ("Success", true);
    };

    //when user deposits icp to product
    public func mintaICP (amount : Nat) : async (Text, Bool){
        aICP_outstanding += amount;
        return ("Success", true);
    };

//burning
    //when user redeems cycles from product
    public func burnaCycles (amount : Nat) : async (Text, Bool){
        aCycle_outstanding -= amount;
        return ("Success", true);
    };

    //when user redeems icp from product
    public func burnaICP (amount : Nat) : async (Text, Bool){
        aICP_outstanding -= amount;
        return ("Success", true);
    };

//utilizing reserve canister!!


};
