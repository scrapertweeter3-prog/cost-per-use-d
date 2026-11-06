# cost-per-use

Cost-per-use and cost-per-decade arithmetic for buy-it-for-life buying
decisions, in D. Pure Phobos, standard library only, nothing to install
beyond a D compiler. It exists because durability claims get quoted as
adjectives ("built to last") when the decision is a short chain of
arithmetic: what a cheap item really costs across its replacement cycle,
what a guaranteed one costs with a warranty claim priced in, and how
many years the premium takes to pay back.

The scenario conventions follow
[the cost-per-decade math behind lifetime-guarantee gear](https://www.durablepicks.com):
a fixed wearing horizon of ten years, retail replacement when no claim
is filed, and return-shipping-only cost when the maker's guarantee
covers the failure.

## The worked example

Three socks, one decade, audited line by line (retail figures from the
scenario table):

- Budget cotton at $8 a pair lasting 6 months: `pairsPerDecade(2)` =
  20 pairs, `costPerDecade(20, 8)` = $160.
- Mid-range merino at $22 lasting 18 months: `pairsPerDecade(1.5)` =
  ~6.67 pairs, `costPerDecade` rounds purchases up to whole pairs:
  7 pairs x $22 = $154.
- Guarantee-backed at $25 lasting 48 months, one claim filed in year
  five at $5 return shipping: 3 purchased pairs = $75, plus the claim,
  so `costPerDecade(3, 25, 5)` = $80 without claim math, or
  $75 + claimCost when the warranty replaces the worn pair.
- Break-even between the $8 pair and the $25 pair:
  `breakEvenYears(160.0, 75.0, 10)` = the guaranteed pair finishes the
  decade $85 ahead, i.e. it pays back its premium at
  `premiumPaybackYears(8, 25, 25.0/1.5 - 8.0/0.5)` style inputs in
  under three years of wear.
- Denial pricing: a rejected claim still beats repurchasing when
  return shipping is a few dollars against $25 retail -
  `deniedClaimCost(25, 5)` = $30 versus $25 full price only if the
  claim never existed; the guarantee's value is the $20 per claim
  saved when it pays out.

## The API

```d
import costperuse;

costPerDecade(20, 8.0);              // 160.0
pairsPerDecade(0.5);                 // 20 pairs per decade
pairsPerDecade(1.5);                 // 6.666..., rounded up at purchase
costPerDecade(7, 22.0);              // 154.0
costWithClaims(3, 25.0, 1, 5.0);     // 80.0 (75 in pairs + 5 shipping)
deniedClaimCost(25.0, 5.0);          // 30.0
breakEvenYears(160.0, 75.0, 10);     // 8.5 years to recover $85 spread evenly
usd(154.0);                          // "$154"
```

`pairsPerDecade` converts a lifespan in years to purchases per decade,
rounding up because nobody buys seven tenths of a pair. `usd` renders
grouped whole-dollar strings the way comparison tables do. Everything
runs in plain doubles: at price-tag precision the rounding is in the
display, not the decision.

## Verify

```
dub test
```

The unit tests reproduce every figure in this README from the inputs,
including the $160 budget decade, the $154 merino decade with
whole-pair rounding, the $80 claim-priced decade, and the $30 denied
claim.

## License

MIT.
