# dbt-fabric-serverless

This is a forked version from [dbt-fabric adapter](https://github.com/microsoft/dbt-fabric), which is officially maintained by Microsoft. Since the official adapter does not support Serverless Pool, this fork aims to do it so.

**Disclaimer** - I cannot ensure this adapter would work 100% correct for all cases as I have not tested all features. If you mainly work with view creations and unit testing, it should work well. If you need to create snapshots or create tables from seeds, you will need to wait as I have not changed those materializations to conform the Serverless Pools' capability yet.

## Differences:

Since Serverless Pool does not allow to create tables, this leads to many features have to use "view" alternatively.

- **Test materialization** uses a view as the medium containing testing result instead of a temp table.
- **External materialization** is supported in this fork by utilizing CETAS (Create External Table As Select) feature in the Serverless Pool. To create an external, you need to declare these properties:
> - materialized: 'external'
> - location: '<Relative Azure Blob Storage/Data Lake location>', e.g., 'Folder1/Folder2'
> - data_source: '<Predefined Data Source>', e.g., 'AzureDataLakeSource'
> - file_format: '<Predefined External File Format>', e.g., 'SynapseParquetSnappyFormat'
> 
> You should predefine those resources by following these steps
>
> -- Create credential for the target blob container
>
> IF NOT EXISTS (SELECT * FROM sys.credentials WHERE name = 'https://<storage_account>.dfs.core.windows.net/<blob_container>')
BEGIN
    CREATE CREDENTIAL [https://<storage_account>.dfs.core.windows.net/<blob_container>]
        WITH IDENTITY = 'Managed Identity'
END
>
> -- Create Database Credential
>
> CREATE DATABASE SCOPED CREDENTIAL SynapseIdentity
WITH IDENTITY = 'Managed Identity';
>
> -- Create External Data Source
>
> CREATE EXTERNAL DATA SOURCE [AzureDataLakeSource]
	WITH (
		LOCATION = 'abfss://@dlsprd001.dfs.core.windows.net' ,
        CREDENTIAL = SynapseIdentity
	)
>
> -- Create External File Format: Parquet with Snappy Compression
>
> IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetSnappyFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseParquetSnappyFormat] 
	WITH ( FORMAT_TYPE = PARQUET,
	       DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
			)


## Documentation

> Setup remains the same as the official adapter

We've bundled all documentation on the dbt docs site
* [Profile setup & authentication](https://docs.getdbt.com/docs/core/connect-data-platform/fabric-setup)
* [Adapter documentation, usage and important notes](https://docs.getdbt.com/reference/resource-configs/fabric-configs)

## Installation

This adapter requires the Microsoft ODBC driver to be installed:
[Windows](https://docs.microsoft.com/nl-be/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver16#download-for-windows) |
[macOS](https://docs.microsoft.com/nl-be/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver16) |
[Linux](https://docs.microsoft.com/nl-be/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16)

<details><summary>Debian/Ubuntu</summary>
<p>

Make sure to install the ODBC headers as well as the driver linked above:

```shell
sudo apt-get install -y unixodbc-dev
```

</p>
</details>


```shell
pip install git+https://github.com/daihuynh/dbt-fabric-serverless
```

## Changelog

See [the changelog from the official adapter](CHANGELOG.md)

## Contributing

[![Unit tests](https://github.com/microsoft/dbt-fabric/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/microsoft/dbt-fabric/actions/workflows/unit-tests.yml)
[![Integration tests on Azure](https://github.com/microsoft/dbt-fabric/actions/workflows/integration-tests-azure.yml/badge.svg)](https://github.com/microsoft/dbt-fabric/actions/workflows/integration-tests-azure.yml)
[![Publish Docker images for CI/CD](https://github.com/microsoft/dbt-fabric/actions/workflows/publish-docker.yml/badge.svg)](https://github.com/microsoft/dbt-fabric/actions/workflows/publish-docker.yml)

This adapter is Microsoft-maintained.
You are welcome to contribute by creating issues, opening or reviewing pull requests.
If you're unsure how to get started, check out our [contributing guide](CONTRIBUTING.md).

## License

[![PyPI - License](https://img.shields.io/pypi/l/dbt-fabric)](https://github.com/microsoft/dbt-fabric/blob/main/LICENSE)

## Code of Conduct

This project and everyone involved is expected to follow the [Microsoft Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
