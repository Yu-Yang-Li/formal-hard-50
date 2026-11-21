import Mathlib

theorem lie_bijection_additive_on_trace_zero
    (K R : Type*) [Field K] [LieRing R]
    (n : ℕ) (hn : 2 ≤ n)
    (α : Matrix (Fin n) (Fin n) K → R)
    (hbij : Function.Bijective α)
    (hbracket : ∀ x y : Matrix (Fin n) (Fin n) K, α ⁅x, y⁆ = ⁅α x, α y⁆) :
    ∀ x y : Matrix (Fin n) (Fin n) K,
      Matrix.trace x = 0 → Matrix.trace y = 0 → α (x + y) = α x + α y := by
  sorry
