import Mathlib

theorem exists_goldbach_like :
    ∃ N₀ : ℤ, ∀ N : ℤ, Even N → N₀ ≤ N →
      ∃ p q r : ℕ, Nat.Prime p ∧ Nat.Prime q ∧ (r = 1 ∨ Nat.Prime r) ∧
        N = (p : ℤ) + (r : ℤ) * (q : ℤ) ∧ (r : ℝ) ≤ (q : ℝ) ^ ((9 : ℝ) / 10) := by
  sorry
