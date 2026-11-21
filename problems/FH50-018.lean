import Mathlib

open Filter

theorem binary_digit_sum_limit_lower_bound (t : ℤ) (ht : 1 ≤ t) :
    let s₂ : ℕ → ℕ := fun m => (Nat.digits 2 m).sum
    ∃ c : ℝ,
      Tendsto
        (fun N : ℕ =>
          ((Finset.filter (fun n : ℕ => s₂ (n + t.toNat) ≥ s₂ n) (Finset.range N)).card : ℝ) /
            (N : ℝ))
        atTop (nhds c) ∧
        c ≥ (1 : ℝ) / 2 + (2 : ℝ) ^ (-(2 * s₂ t.toNat + 1 : ℤ)) := by
  sorry
