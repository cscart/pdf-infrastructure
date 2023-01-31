# PDF Converter Infrastructure

Service that converts HTML documents to PDF.

# System requirements

* Docker
* Docker Compose

# Running locally

1. Clone the environment repository:
    ```
    $ git clone https://github.com/cscart/pdf-infrastructure.git pdf-infrastructure
    $ cd pdf-infrastructure
    ```
2. Put your SSL certificates into the `ssl` directory. Certificate and key files should be named after the domain your service will be hosted at. E.g., if you host your PDF Converter at https://pdf.example.com, certificate must be named `pdf.example.com.crt` and key `pdf.example.com.key`.
3. Clone source code of the [converter](https://github.com/cscart/pdf) itself into the `compose/images/pdf` directory:
    ```
    $ git clone https://github.com/cscart/pdf.git compose/images/pdf
    ```
4. In the `compose` directory:
    1. Copy `.env.dist` to `.env`.
    2. Set the domain of your service in the `GENWORKER_ADDRESS` variable and its external IP in the `GW_EXTERNAL_IP` variable in the `.env` file.
5. Run `make gw_base` in the root directory to build images.
6. Run `make gw_prod` to start project containers.
7. Run `make gw_prp` to install composer packages.

# Running with previously built image from Docker registry

1. Clone the environment repository:
    ```
    $ git clone https://github.com/cscart/pdf-infrastructure.git pdf-infrastructure
    $ cd pdf-infrastructure
    ```
2. Put your SSL certificates into the `ssl` directory. Certificate and key files should be named after the domain your service will be hosted at. E.g., if you host your PDF Converter at https://pdf.example.com, certificate must be named `pdf.example.com.crt` and key `pdf.example.com.key`.
3. Clone source code of the [converter](https://github.com/cscart/pdf) itself into the `compose/images/pdf` directory:
    ```
    $ git clone https://github.com/cscart/pdf.git compose/images/pdf
    ```
4. In the `compose` directory:
    1. Copy `.env.dist` to `.env`.
    2. Set the domain of your service in the `GENWORKER_ADDRESS` variable and its external IP in the `GW_EXTERNAL_IP` variable in the `.env` file.
    3. Set the address of the Docker registry in the `REGISTRY` variable in the `.env` file.
    User must be logged in in the Docker registry to interact with it.
5. Run `make gw_registry` in the root directory to download built images from the Docker registry.
6. Run `make gw_prp_registry` to install composer packages.
