import Mathlib

theorem lagrange_constant_lft_value_set
    (a b c d : ℤ)
    (hdet : a * d - b * c ≠ 0)
    (hgcd : Nat.gcd (Int.gcd a b) (Int.gcd c d) = 1) :
    let lagrangeConstant : ℝ → ℝ := fun y =>
      sSup { μ : ℝ |
        ∃ᶠ q : ℕ in Filter.atTop,
          0 < q ∧ ∃ p : ℤ,
            |y - (p : ℝ) / (q : ℝ)| < 1 / (μ * (q : ℝ) ^ 2) }
    let Bad : Set ℝ :=
      { y : ℝ | Irrational y ∧
        ∃ C : ℝ, 0 < C ∧
          ∀ (p : ℤ) (q : ℕ), 0 < q →
            C / (q : ℝ) ^ 2 ≤ |y - (p : ℝ) / (q : ℝ)| }
    let M : ℝ → ℝ := fun x =>
      (((a : ℝ) * x + (b : ℝ)) / ((c : ℝ) * x + (d : ℝ)))
    { r : ℝ | ∃ x : ℝ, x ∈ Bad ∧ r = lagrangeConstant (M x) / lagrangeConstant x } =
      Set.Icc (1 / |((a * d - b * c : ℤ) : ℝ)|) |((a * d - b * c : ℤ) : ℝ)| := by
  sorry
