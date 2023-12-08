# Use a base image with CUDA support
FROM nvidia/cuda:12.3.1-devel-ubuntu22.04

# Install Miniconda to manage Python environments and packages
RUN apt-get update && apt-get install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh

# Add Miniconda to PATH
ENV PATH=/miniconda/bin:${PATH}

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container
COPY requirements.txt /app/

# Install Python packages specified in requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Freeze the installed versions for reproducibility
RUN pip freeze > /app/frozen_requirements.txt

# Expose the port Jupyter will run on
EXPOSE 8888

# Start Jupyter Notebook with settings to allow root access and specify the notebook directory
CMD ["jupyter", "notebook", "--notebook-dir=/app/notebooks", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
