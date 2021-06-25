import Nat "mo:base/Nat";
import User "canister:user";
import Text "mo:base/Text";

actor treasury {

    //initiliazing icp tokens and cycle tokens to then send to user canister
    var icp : Nat = 0;
    var cycles : Nat = 0;

    public func icp_balance(): async Nat {
        return icp;
    };

    public func cycles_balance(): async Nat {
        return cycles;
    };

    public func mintICP (amount : Nat) : async (Text, Bool){
        icp += amount;
        return ("Success", true);
    };

    public func transferICP (amount : Nat) : async (Text, Bool){
        if (icp > amount){
            icp -= amount;
            let temp = await User.increaseICP(amount);
            return ("Success", true);
        };
        return ("Failure - Transfer Amount Exceeds Supply", false); 
    };

    public func mintCycles (amount : Nat) : async (Text, Bool){
        cycles += amount;
        return ("Success", true);
    };

    public func transferCycles (amount : Nat) : async (Text, Bool){
        if (cycles > amount){
            cycles -= amount;
            let temp = await User.increaseCycles(amount); 
            return ("Success", true);
        };
        return ("Failure - Transfer Amount Exceeds Supply", false); 
    };



};
