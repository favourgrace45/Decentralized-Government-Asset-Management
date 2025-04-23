;; Condition Assessment Contract
;; Tracks state of government assets

;; Rating scale: u1 (poor) to u5 (excellent)
(define-map asset-conditions
  { asset-id: uint, assessment-date: uint }
  {
    rating: uint,
    notes: (string-utf8 500),
    assessed-by: principal,
    next-assessment-date: uint
  }
)

;; Store the latest assessment for quick lookup
(define-map latest-assessment
  { asset-id: uint }
  { assessment-date: uint }
)

;; Record a new condition assessment
(define-public (record-assessment
    (asset-id uint)
    (rating uint)
    (notes (string-utf8 500))
    (next-assessment-date uint))
  (let
    (
      (current-time u0)
    )
    ;; Validate rating is between 1 and 5
    (asserts! (and (>= rating u1) (<= rating u5)) (err u400))

    ;; Record the assessment
    (map-set asset-conditions
      { asset-id: asset-id, assessment-date: current-time }
      {
        rating: rating,
        notes: notes,
        assessed-by: tx-sender,
        next-assessment-date: next-assessment-date
      }
    )

    ;; Update the latest assessment reference
    (map-set latest-assessment
      { asset-id: asset-id }
      { assessment-date: current-time }
    )

    (ok true)
  )
)

;; Get the latest assessment for an asset
(define-read-only (get-latest-assessment (asset-id uint))
  (let
    (
      (latest (map-get? latest-assessment { asset-id: asset-id }))
    )
    (match latest
      latest-info (map-get? asset-conditions {
        asset-id: asset-id,
        assessment-date: (get assessment-date latest-info)
      })
      none
    )
  )
)

;; Get a specific assessment by date
(define-read-only (get-assessment-by-date (asset-id uint) (assessment-date uint))
  (map-get? asset-conditions { asset-id: asset-id, assessment-date: assessment-date })
)

;; Get all assets needing assessment soon (within the next X blocks)
(define-read-only (get-assets-due-assessment (within-blocks uint))
  none
)
