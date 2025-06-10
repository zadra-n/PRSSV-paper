# LAZYPIPE 3.0 Output Statistics

This folder contains the output statistics for 6 samples processed through the LAZYPIPE 3.0 bioinformatics pipeline for viral discovery.

## Samples Included
- NW
- SE
- SW
- Lo1
- Lo2
- Lo3

## File Structure
Each sample has one output file in OpenDocument Spreadsheet (.ods) format with the naming convention:  
`[sample_name]_abund_tables.ods`

- `NW_abund_tables.ods`
- `SE_abund_tables.ods`
- `SW_abund_tables.ods`
- `Lo1_abund_tables.ods`
- `Lo2_abund_tables.ods`
- `Lo3_abund_tables.ods`

## Table Contents
Each .ods file contains the following 9 sheets/tabs:

1. **Viral Taxonomy**
   - `vi_family`: Read abundance mapped to viral families
   - `vi_genus`: Read abundance mapped to viral genera
   - `vi_species`: Read abundance mapped to viral species

2. **Bacterial Taxonomy**
   - `ba_family`: Read abundance mapped to bacterial families
   - `ba_genus`: Read abundance mapped to bacterial genera
   - `ba_species`: Read abundance mapped to bacterial species

3. **General Taxonomy**
   - `skiing`: Read abundance mapped to superkingdoms
   - `family`: Read abundance mapped to families (all organisms)
   - `genus`: Read abundance mapped to genera (all organisms)
