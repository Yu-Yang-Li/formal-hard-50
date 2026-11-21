import Mathlib

theorem exists_equal_weight_spherical_five_design (d : ℕ) (hd : 1 ≤ d) :
    ∃ X : Finset (Metric.sphere (0 : EuclideanSpace ℝ (Fin d)) (1 : ℝ)),
      X.card ≤ 72 * d ^ 2 ∧
        ∀ α : Fin d → ℕ,
          Finset.univ.sum α ≤ 5 →
            (X.card : ℝ)⁻¹ *
                (X.sum fun x =>
                  Finset.univ.prod fun i : Fin d =>
                    ((x : EuclideanSpace ℝ (Fin d)) i) ^ (α i)) =
              if h : ∀ i : Fin d, Even (α i) then
                (Finset.univ.prod fun i : Fin d =>
                    ((Nat.factorial (α i) : ℝ) /
                      ((2 : ℝ) ^ (α i / 2) * (Nat.factorial (α i / 2) : ℝ)))) /
                  ((Finset.range (Finset.univ.sum α / 2)).prod fun j : ℕ =>
                    (d : ℝ) + 2 * (j : ℝ))
              else
                0 := by
  sorry
