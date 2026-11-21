import Mathlib

theorem constant_width_convex_body_volume_lower_bound
    (K : Set (EuclideanSpace ℝ (Fin 3))) (d : ℝ)
    (hK_compact : IsCompact K)
    (hK_convex : Convex ℝ K)
    (hK_body : (interior K).Nonempty)
    (h_width : ∀ u : EuclideanSpace ℝ (Fin 3), ‖u‖ = 1 →
      sSup ((fun x : EuclideanSpace ℝ (Fin 3) => inner ℝ u x) '' K) -
        sInf ((fun x : EuclideanSpace ℝ (Fin 3) => inner ℝ u x) '' K) = d) :
    (MeasureTheory.volume K).toReal ≥ (4 * Real.pi / 33) * d ^ 3 := by
  sorry
