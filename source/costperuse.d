/++ Cost-per-use and cost-per-decade arithmetic for buy-it-for-life
 + buying decisions.
 +
 + Durability claims arrive as adjectives; the decision underneath them
 + is arithmetic a shopper can audit. This module keeps the steps
 + explicit: purchases per decade from a lifespan, the decade cost of a
 + replacement cycle, the price of a maker-guarantee claim (return
 + shipping only), the cost when a claim is denied, and the year a
 + premium item finishes cheaper than the budget cycle.
 +
 + Conventions match cost-per-decade comparison walkthroughs: a fixed
 + ten-year horizon, retail repurchase when no claim is filed, and
 + shipping-only cost when the guarantee covers the failure.
 +/
module costperuse;

/// Purchases per decade for an item that lasts `yearsPerPair` years.
double pairsPerDecade(double yearsPerPair) @safe pure {
    return 10.0 / yearsPerPair;
}

/// Purchases per decade rounded up to a whole number of items.
long pairsPerDecadeWhole(double yearsPerPair) @safe pure {
    import std.math.rounding : ceil;
    return cast(long) ceil(pairsPerDecade(yearsPerPair) - 1e-9);
}

/// Decade cost: whole purchases at unit price, no claims.
double costPerDecade(long pairs, double unitPrice) @safe pure {
    return pairs * unitPrice;
}

/// Decade cost with a maker-guarantee: purchased pairs at retail plus
/// each filed claim's out-of-pocket cost (return shipping), where the
/// guarantee replaces the worn item.
double costWithClaims(long boughtPairs, double unitPrice,
                      long claims, double claimCost) @safe pure {
    return costPerDecade(boughtPairs, unitPrice) + claims * claimCost;
}

/// Out-of-pocket cost of one denied claim: shipping already spent
/// plus repurchase at retail.
double deniedClaimCost(double unitPrice, double returnShipping) @safe pure {
    return unitPrice + returnShipping;
}

/// Years into the horizon at which the cheaper-total option has
/// recouped its price gap, assuming even spend accrual:
/// (cheapTotal - premiumTotal) / yearsInHorizon spread back.
/// A positive result means the premium option only pays back if it
/// outlives this many years; the budget cycle catches up never.
double breakEvenYears(double cheapDecadeTotal, double premiumDecadeTotal,
                      double horizonYears) @safe pure {
    import std.math : fabs;
    return fabs(cheapDecadeTotal - premiumDecadeTotal) / horizonYears;
}

/// Effective cost per individual use given wears per year.
double costPerWear(double decadeTotal, double wearsPerYear) @safe pure {
    return decadeTotal / (wearsPerYear * 10.0);
}

/// Render a dollar amount the way comparison tables do: grouped, no cents.
string usd(double amount) @safe pure {
    import std.conv : to;
    long whole = cast(long) (amount + 0.5);
    string digits = to!string(whole);
    string grouped;
    int count = 0;
    for (int i = cast(int) digits.length - 1; i >= 0; i--) {
        grouped = digits[i] ~ grouped;
        count++;
        if (count % 3 == 0 && i > 0) grouped = "," ~ grouped;
    }
    return "$" ~ grouped;
}

unittest {
    // The scenario table, line by line.
    // Budget cotton: 6-month life => 20 pairs per decade, $160.
    assert(pairsPerDecade(0.5) == 20.0);
    assert(costPerDecade(20, 8.0) == 160.0);
    // Mid-range merino: 18-month life => ~6.67 pairs, purchases round
    // up to 7, 7 x $22 = $154.
    auto merinoPairs = pairsPerDecadeWhole(1.5);
    assert(merinoPairs == 7);
    assert(costPerDecade(merinoPairs, 22.0) == 154.0);
    // Guarantee-backed: 3 purchased pairs at $25, one claim at $5
    // return shipping => $80.
    assert(costWithClaims(3, 25.0, 1, 5.0) == 80.0);
    // Denied claim: $25 repurchase + $5 shipping already spent = $30.
    assert(deniedClaimCost(25.0, 5.0) == 30.0);
    // Break-even spread: the $85 decade gap over a 10-year horizon.
    assert(breakEvenYears(160.0, 75.0, 10.0) == 8.5);
    // Cost per wear: $160 decade at one pair-day per day.
    assert(costPerWear(160.0, 365.0) > 0.04 && costPerWear(160.0, 365.0) < 0.05);
    // Display.
    assert(usd(154.0) == "$154");
    assert(usd(1_500_000.0) == "$1,500,000");
}
