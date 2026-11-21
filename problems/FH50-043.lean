import Mathlib

theorem reciprocal_covering_exists {n : ℕ} (hn : 0 < n) (a : Fin n → ℕ)
    (ha_pos : ∀ i : Fin n, 0 < a i)
    (h_sum : (∑ i : Fin n, (1 : ℚ) / (a i : ℚ)) ≤ (5 : ℚ) / 6) :
    ∃ f : ℤ → Fin n, ∀ i : Fin n, ∀ k : ℤ,
      ∃ j : ℤ, k ≤ j ∧ j < k + (a i : ℤ) ∧ f j = i := by
  sorry
