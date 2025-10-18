🧬 DNA Data Ownership Contract

Overview

This smart contract enables individuals or organizations to prove and transfer ownership of genomic data by minting non-fungible tokens (NFTs) on the Stacks blockchain. Each token represents a unique DNA data record with verifiable metadata, providing transparency, traceability, and control over sensitive genomic information.

Key Features

NFT-based DNA Ownership: Each token represents ownership proof of a unique genomic dataset.

Metadata Storage: Stores essential data such as data hash, sample type, sequencing lab, and timestamp.

Ownership Transfer: Secure and verifiable token transfer between standard principals.

Read-Only Access: Provides multiple view functions to retrieve ownership and metadata information.

Data Integrity: Uses SHA-256 or equivalent hashes to ensure data authenticity and prevent tampering.

Contract Components
Constants

contract-owner: The account that deployed the contract.

Error codes for various invalid states (e.g., unauthorized access, invalid input, nonexistent token).

Data Variables

last-token-id: Tracks the most recently minted token ID.

Data Maps

token-owners: Maps each token ID to its current owner.

token-metadata: Stores associated metadata such as:

{
  data-hash: (buff 32),
  timestamp: uint,
  sample-type: (string-ascii 50),
  sequencing-lab: (string-ascii 100)
}

Non-Fungible Token

dna-ownership: The NFT definition representing each unique DNA ownership record.

Public Functions
1. mint-dna-token

Purpose: Mints a new DNA ownership NFT and stores its metadata.
Parameters:

recipient (principal) — Address receiving the NFT

data-hash (buff 32) — Unique hash of the genomic data

sample-type (string-ascii 50) — Type of biological sample

sequencing-lab (string-ascii 100) — Name of sequencing lab

Returns: Token ID (uint) of the newly created NFT.

Validations:

Ensures recipient is a standard principal.

Verifies that all string fields and hash are non-empty.

2. transfer

Purpose: Transfers ownership of a specific token to another principal.
Parameters:

token-id (uint)

sender (principal)

recipient (principal)

Returns: (ok true) on success.
Validations: Ensures that the sender is the current token owner and both parties are standard principals.

Read-Only Functions
Function	Description
get-owner	Returns the owner of a given token ID
get-token-metadata	Retrieves the metadata of a given token
get-last-token-id	Returns the latest minted token ID
get-token-uri	Placeholder for linking off-chain metadata (currently returns none)
token-exists	Checks whether a token exists
Usage Example
;; Mint a new DNA token
(contract-call? .dna-data-ownership mint-dna-token 
    'SP3FBR2AGKQ2ZH6KPT7KPYK0Z7N8A1TDP6ZQK9AB 
    0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890 
    "Saliva Sample" 
    "GenomeLab NG")

;; Transfer ownership
(contract-call? .dna-data-ownership transfer u1 'SP3F... 'SP2K...)

License
This contract is released under the MIT License.