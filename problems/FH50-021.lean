import Mathlib

def benchmarkRamseyProperty (a b m : ℕ) : Prop :=
  ∀ G : SimpleGraph (Fin m),
    (∃ C : Finset (Fin m), C.card = a ∧
      ∀ u ∈ C, ∀ v ∈ C, u ≠ v → G.Adj u v) ∨
    (∃ I : Finset (Fin m), I.card = b ∧
      ∀ u ∈ I, ∀ v ∈ I, u ≠ v → ¬ G.Adj u v)

def benchmarkRamseyThreshold (k n : ℕ) : Prop :=
  ∃ r : ℕ,
    0 < r ∧
    benchmarkRamseyProperty k k r ∧
    (∀ m : ℕ, 0 < m → benchmarkRamseyProperty k k m → r ≤ m) ∧
    r ≤ n

noncomputable def benchmarkInducedDegree {n : ℕ}
    (G : SimpleGraph (Fin n)) (S : Finset (Fin n)) (v : Fin n) : ℕ := by
  classical
  exact (S.filter (fun w => G.Adj v w)).card

noncomputable def benchmarkInducedMaxDegree {n : ℕ}
    (G : SimpleGraph (Fin n)) (S : Finset (Fin n)) : ℕ :=
  S.sup (fun v => benchmarkInducedDegree G S v)

noncomputable def benchmarkHasMaximumRepetitions {n : ℕ}
    (k : ℕ) (G : SimpleGraph (Fin n)) (S : Finset (Fin n)) : Prop := by
  classical
  exact k ≤ S.card ∧
    k ≤ (S.filter (fun v =>
      benchmarkInducedDegree G S v = benchmarkInducedMaxDegree G S)).card

def arxivleanConjecture : Prop :=
  ∀ k : ℕ, 2 ≤ k → ∃ a : ℝ,
  ∀ n : ℕ, ∀ G : SimpleGraph (Fin n),
    benchmarkRamseyThreshold k n →
    ∃ Z : Finset (Fin n),
      benchmarkHasMaximumRepetitions k G (Finset.univ \ Z) ∧
      (Z.card : ℝ) ≤
        a * Real.sqrt ((benchmarkInducedMaxDegree G Finset.univ : ℕ) : ℝ)
