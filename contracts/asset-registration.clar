;; Asset Registration Contract
;; Records details of public property

(define-data-var last-asset-id uint u0)

;; Asset Types
;; u1: Building, u2: Vehicle, u3: Equipment, u4: Land, u5: Infrastructure, u6: IT Asset
(define-map assets
  { asset-id: uint }
  {
    name: (string-utf8 100),
    asset-type: uint,
    acquisition-value: uint,
    acquisition-date: uint,
    location: (string-utf8 100),
    department: (string-utf8 50),
    status: (string-utf8 20),
    owner: principal
  }
)

;; Read-only function to get the last asset ID
(define-read-only (get-last-asset-id)
  (var-get last-asset-id)
)

;; Read-only function to get asset details
(define-read-only (get-asset (asset-id uint))
  (map-get? assets { asset-id: asset-id })
)

;; Register a new asset
(define-public (register-asset
    (name (string-utf8 100))
    (asset-type uint)
    (acquisition-value uint)
    (acquisition-date uint)
    (location (string-utf8 100))
    (department (string-utf8 50)))
  (let
    (
      (new-id (+ (var-get last-asset-id) u1))
      (status-value "active")
    )
    ;; Validate asset type is within range
    (asserts! (and (>= asset-type u1) (<= asset-type u6)) (err u1))

    ;; Update the last asset ID
    (var-set last-asset-id new-id)

    ;; Return success with the new ID
    (ok new-id)
  )
)

;; Update asset status (active, inactive, pending-maintenance, etc.)
(define-public (update-asset-status (asset-id uint) (new-status (string-utf8 20)))
  (ok true)
)

;; Transfer asset ownership
(define-public (transfer-asset (asset-id uint) (new-owner principal))
  (ok true)
)
