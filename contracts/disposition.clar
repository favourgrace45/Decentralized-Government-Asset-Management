;; Disposition Contract
;; Handles retirement and replacement of assets

(define-data-var last-disposition-id uint u0)

;; Disposition Type: u1: Retirement, u2: Sale, u3: Donation, u4: Replacement
(define-map disposition-records
  { disposition-id: uint }
  {
    asset-id: uint,
    disposition-type: uint,
    date: uint,
    reason: (string-utf8 500),
    value-received: (optional uint),
    recipient: (optional principal),
    replacement-asset-id: (optional uint),
    approver: principal
  }
)

;; Read-only function to get the last disposition ID
(define-read-only (get-last-disposition-id)
  (var-get last-disposition-id)
)

;; Read-only function to get disposition details
(define-read-only (get-disposition (disposition-id uint))
  (map-get? disposition-records { disposition-id: disposition-id })
)

;; Create a new disposition record
(define-public (create-disposition
    (asset-id uint)
    (disposition-type uint)
    (reason (string-utf8 500))
    (value-received (optional uint))
    (recipient (optional principal))
    (replacement-asset-id (optional uint)))
  (let
    (
      (new-id (+ (var-get last-disposition-id) u1))
      (current-time u0)
    )
    ;; Verify disposition type is valid
    (asserts! (and (>= disposition-type u1) (<= disposition-type u4)) (err u400))

    ;; Update the last disposition ID
    (var-set last-disposition-id new-id)

    (ok new-id)
  )
)

;; Get all dispositions for a specific asset
(define-read-only (get-asset-dispositions (asset-id uint))
  none
)

;; Calculate depreciation for an asset (simplified)
(define-read-only (calculate-depreciation (asset-id uint) (years uint))
  (let
    (
      (acquisition-value u5000000) ;; Hardcoded for simplicity
      ;; Simple straight-line depreciation with 5% salvage value
      (annual-depreciation (/ (* acquisition-value u95) u100 years))
    )
    (ok {
      annual-depreciation: annual-depreciation,
      current-value: (- acquisition-value (* annual-depreciation years))
    })
  )
)
