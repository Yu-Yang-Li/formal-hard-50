import Mathlib

theorem periodic_of_rectangularPatternComplexity_four_le
    (𝓐 : Type*) [Fintype 𝓐] (η : ℤ × ℤ → 𝓐) :
    (∃ n : ℕ, 0 < n ∧
      (Set.range (fun p : ℤ × ℤ => fun ij : Fin 4 × Fin n =>
        η (p.1 + ((ij.1 : ℕ) + 1 : ℤ), p.2 + ((ij.2 : ℕ) + 1 : ℤ)))).ncard ≤ 4 * n) →
    ∃ a b : ℤ, (a, b) ≠ (0, 0) ∧
      ∀ x y : ℤ, η (x + a, y + b) = η (x, y) := by
  sorry
