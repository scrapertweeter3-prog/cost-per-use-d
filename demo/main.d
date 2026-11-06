import std.stdio;
import costperuse;

void main() {
    writeln("One decade, three sock strategies (scenario-table figures):");
    writeln("  budget cotton, 6-month life: 20 pairs x $8 = ",
            usd(costPerDecade(20, 8.0)));
    auto merino = pairsPerDecadeWhole(1.5);
    writeln("  mid-range merino, 18-month life: ", merino,
            " pairs x $22 = ", usd(costPerDecade(merino, 22.0)));
    writeln("  guarantee-backed, 48-month life, one claim: ",
            usd(costWithClaims(3, 25.0, 1, 5.0)));
    writeln("  denied claim out-of-pocket: ",
            usd(deniedClaimCost(25.0, 5.0)));
    writeln("  decade gap between budget and guaranteed: ",
            usd(160.0 - 75.0), " (",
            breakEvenYears(160.0, 75.0, 10.0),
            " dollars per horizon-year)");
}
