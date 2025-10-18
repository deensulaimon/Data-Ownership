;; DNA Data Ownership Contract
;; Store proof of ownership of genomic data as NFTs

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-token-exists (err u102))
(define-constant err-token-not-found (err u103))
(define-constant err-invalid-data-hash (err u104))
(define-constant err-invalid-sample-type (err u105))
(define-constant err-invalid-sequencing-lab (err u106))
(define-constant err-invalid-recipient (err u107))
(define-constant err-invalid-sender (err u108))

;; Data Variables
(define-data-var last-token-id uint u0)

;; Data Maps
(define-map token-owners uint principal)
(define-map token-metadata uint {
    data-hash: (buff 32),
    timestamp: uint,
    sample-type: (string-ascii 50),
    sequencing-lab: (string-ascii 100)
})

;; Non-Fungible Token Definition
(define-non-fungible-token dna-ownership uint)

;; Public Functions

;; Mint a new DNA ownership NFT
(define-public (mint-dna-token (recipient principal) (data-hash (buff 32)) (sample-type (string-ascii 50)) (sequencing-lab (string-ascii 100)))
    (let ((token-id (+ (var-get last-token-id) u1)))
        (asserts! (is-standard recipient) err-invalid-recipient)
        (asserts! (> (len data-hash) u0) (err u104))
        (asserts! (> (len sample-type) u0) (err u105))
        (asserts! (> (len sequencing-lab) u0) (err u106))
        (try! (nft-mint? dna-ownership token-id recipient))
        (map-set token-owners token-id recipient)
        (map-set token-metadata token-id {
            data-hash: data-hash,
            timestamp: block-height,
            sample-type: sample-type,
            sequencing-lab: sequencing-lab
        })
        (var-set last-token-id token-id)
        (ok token-id)
    )
)

;; Transfer DNA ownership NFT
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-standard sender) err-invalid-sender)
        (asserts! (is-standard recipient) err-invalid-recipient)
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        (asserts! (is-eq (some sender) (nft-get-owner? dna-ownership token-id)) err-not-token-owner)
        (try! (nft-transfer? dna-ownership token-id sender recipient))
        (map-set token-owners token-id recipient)
        (ok true)
    )
)

;; Read-only Functions

;; Get the owner of a specific token
(define-read-only (get-owner (token-id uint))
    (ok (nft-get-owner? dna-ownership token-id))
)

;; Get token metadata
(define-read-only (get-token-metadata (token-id uint))
    (map-get? token-metadata token-id)
)

;; Get the last token ID
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

;; Get token URI (placeholder for future implementation)
(define-read-only (get-token-uri (token-id uint))
    (ok none)
)

;; Check if token exists
(define-read-only (token-exists (token-id uint))
    (is-some (nft-get-owner? dna-ownership token-id))
)