from hail import *
import argparse

def summarizeVDS(self):
    '''
    Generate a summary of VDS including
    total nIndels multiallelics MAF01 MAF05
    '''
    queries = [
        'variants.count()',
        'variants.filter(v => v.isBiallelic).count()',
        'variants.filter(v => va.info.AF.sum() > 0.01 && va.info.AF.sum() < 0.99).count()',
        'variants.filter(v => va.info.AF.sum() > 0.05 && va.info.AF.sum() < 0.95).count()',
        'variants.filter(v => v.contig == "chrX").count()',
        'variants.filter(v => v.isBiallelic() && v.contig == "chrX").count()',
        'variants.filter(v => va.info.AF.sum() > 0.01 && va.info.AF.sum() < 0.99 && v.contig == "chrX").count()',
        'variants.filter(v => va.info.AF.sum() > 0.05 && va.info.AF.sum() < 0.95 && v.contig == "chrX").count()'
    ]
    print(self.query_variants(queries))
    return(self)

VariantDataset.summarizeVDS = summarizeVDS

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Example code for sample QC')
    parser.add_argument('--inputVcf', help='input VDS file')
    parser.add_argument('--output_qc_file', help='Output to sample QC results')
    args = parser.parse_args()

    hc = HailContext()
    vds = hc.import_vcf(args.inputVcf)
    vds.export_samples(args.output_qc_file, 'Samples = s, sa.qc.*')
    vds.variant_qc().summarizeVDS()
