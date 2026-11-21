import Mathlib

theorem rainbow_turan_fan_statement (n t : ℕ) (ht : 2 ≤ t) (hn : 230 * t < n) :
    IsGreatest
      {m : ℕ |
        ∃ (G : SimpleGraph (Fin n)) (c : Sym2 (Fin n) → ℕ),
          (∀ (v : Fin n) (e₁ e₂ : Sym2 (Fin n)),
              e₁ ∈ G.incidenceSet v → e₂ ∈ G.incidenceSet v →
                e₁ ≠ e₂ → c e₁ ≠ c e₂) ∧
          (¬ ∃ (x : Fin n) (w : Fin t × Fin 2 → Fin n),
              Function.Injective w ∧
              (∀ p : Fin t × Fin 2, w p ≠ x) ∧
              (∀ i : Fin t,
                G.Adj x (w (i, 0)) ∧
                G.Adj x (w (i, 1)) ∧
                G.Adj (w (i, 0)) (w (i, 1))) ∧
              Set.InjOn c
                {e : Sym2 (Fin n) |
                  ∃ i : Fin t,
                    e = s(x, w (i, 0)) ∨
                    e = s(x, w (i, 1)) ∨
                    e = s(w (i, 0), w (i, 1))}) ∧
          m = Nat.card G.edgeSet}
      (n ^ 2 / 4 + (t - 1) * (n / 2) - if n % 4 = 2 then 1 else 0) := by
  sorry
