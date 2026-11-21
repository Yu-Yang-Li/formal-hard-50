import Mathlib

theorem integer_programming_distance_bound
    (m n : ℕ) (A : Matrix (Fin m) (Fin n) ℤ) (b : Fin m → ℤ) (c : Fin n → ℝ)
    (xstar : EuclideanSpace ℝ (Fin n))
    (hrank : (A.map (Int.castRingHom ℝ)).rank = m) (hmn : m < n) :
    (let Aℝ : Matrix (Fin m) (Fin n) ℝ := A.map (Int.castRingHom ℝ)
     let P : Set (EuclideanSpace ℝ (Fin n)) :=
       {x | Matrix.mulVec Aℝ x.ofLp = (fun i => (b i : ℝ)) ∧ ∀ i, 0 ≤ x.ofLp i}
     let Pℤ : Set (Fin n → ℤ) :=
       {z | Matrix.mulVec A z = b ∧ ∀ i, 0 ≤ z i}
     let obj : EuclideanSpace ℝ (Fin n) → ℝ := fun x => ∑ i, c i * x.ofLp i
     let objℤ : (Fin n → ℤ) → ℝ := fun z => ∑ i, c i * (z i : ℝ)
     xstar ∈ Set.extremePoints ℝ P ∧
       (∀ x ∈ P, obj x ≤ obj xstar) ∧
       (∃ z ∈ Pℤ, ∀ w ∈ Pℤ, objℤ w ≤ objℤ z) →
       ∃ z ∈ Pℤ,
         (∀ w ∈ Pℤ, objℤ w ≤ objℤ z) ∧
           dist xstar (WithLp.toLp 2 (fun i : Fin n => (z i : ℝ)) : EuclideanSpace ℝ (Fin n)) ≤
             Real.sqrt (((A * A.transpose).det : ℤ) : ℝ) - 1) := by
  sorry
