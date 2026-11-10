# cost-per-use

Library docs for cost-per-use, a D package that prices buy-it-for-life
decisions as arithmetic. The repo README carries the three-sock decade
table and the full function list. This page works the two layers the
table implies: what a single wear costs once the decade total is known,
and what a maker guarantee is worth after claims, paid or denied, enter
the ledger.

## From decade total to cost per wear

`costPerWear` divides a decade total by wears per year times ten. The
denominator matters more than the price tag. The scenario table's budget
cotton pair runs a $160 decade at a wear a day, which is
`costPerWear(160.0, 365.0)` = $0.044 per wear. The guarantee-backed pair
at $80 per decade worn 250 times a year lands at
`costPerWear(80.0, 250.0)` = $0.032. The mid-range merino at $154 and
250 wears a year sits between them at $0.062. Ranked by sticker price
the order is $8, $22, $25; ranked by the cost of one wearing, the
guarantee-backed pair wins and the merino loses to both.

That flip is the whole reason to keep the function explicit. A wardrobe
item worn daily never gets expensive per wear; a dress item worn a
dozen times a year carries its decade total across only 120 wears.

## What a guarantee costs and saves

The library prices a claim at its out-of-pocket shipping only: the maker
replaces the item, the buyer mails the worn one back. On the scenario
figures the claim costs $5 and avoids a $25 retail repurchase, so a paid
claim saves $20. The denied case is the honest baseline:
`deniedClaimCost(25.0, 5.0)` = $30, the $25 repurchase plus the $5
shipping already spent on a claim that went nowhere.

Two consequences fall out of those three numbers. First, filing stays
rational while return shipping is small against retail: the downside is
bounded at the shipping cost, here one fifth of the item price. Second,
the guarantee's decade value scales with claim count. The worked table
prices one claim in year five, which is how $75 of purchased pairs plus
$5 of shipping reaches $80 while the budget column reaches $160.

## The gap in years

The decade gap between the budget cycle and the guarantee-backed cycle
is $80 ($160 against $80). Spread over the ten-year horizon that is
`breakEvenYears(160.0, 80.0, 10.0)` = $8 per horizon year, the premium
paying back steadily from the first year rather than at a distant
crossover. When a premium item's decade total is genuinely lower, there
is no break-even wait at all; the function exists for the cases where a
shorter-lived premium competes with a longer-lived budget buy.

## Reproduce the numbers

```
dub run --config=demo
```

prints the scenario ledger: all three decades, the denied-claim figure,
and the gap. The per-wear figures above come from the same functions:

```d
import costperuse;

auto wear = costPerWear(160.0, 365.0);   // 0.0438 dollars per wear
auto claim = deniedClaimCost(25.0, 5.0); // 30.0
auto perYear = breakEvenYears(160.0, 80.0, 10.0); // 8.0
```

`dub test` checks every figure against the library's own unittests,
including the $160 budget decade, the whole-pair rounding to $154, the
$80 claim-priced decade, and the $30 denied claim.

## Where the complete tables live

The full cost-per-decade comparisons across tools, kitchen, and carry
gear live on [Durable Picks](https://www.durablepicks.com).
