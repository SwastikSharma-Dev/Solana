// SPDX-License-Identifier: MIT
// pragma solidity ^0.6.0;
pragma solidity ^0.8.26;

contract safeMath
{
    uint8 public bigNumber = 255;

    function add() public
    {
        /* in earlier versiond of solidity variables are unchecked
           i.e. no upper bound and lower bound check is done
           for example uint8 has values from 0 to 255 when 1 is added to 255 then it turns out to 255 which should not be permitted.
           so later version (0.8 and above) SafeMath was applied for constraints and check on lower and upper bound.
        */
        // bigNumber=bigNumber+1; //checked in version above 0.8
        unchecked{bigNumber=bigNumber+1;} //Even in later verisons we can implemnet without getting checked by using 'unchecked' keyword.
    }
}