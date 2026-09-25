from flask import Flask, jsonify
import requests

app = Flask(__name__)

FRANKFURTER_URL = "https://api.frankfurter.dev/v2/rates"

# --------------------------------------------------
# Basic service information
# --------------------------------------------------

@app.route("/", methods=["GET"])
def hello():
    return jsonify({
        "service": "Currency Rate API",
        "status": "ok"
    })


# --------------------------------------------------
# Currency rates
# --------------------------------------------------

@app.route("/rates", methods=["GET"])
def rates():

    response = requests.get(
        FRANKFURTER_URL,
        params={
            "base": "EUR",
            "quotes": "USD,CAD"
        },
        timeout=5
    )

    response.raise_for_status()

    rates_today = response.json()

    return jsonify(rates_today)


# --------------------------------------------------
# Kubernetes health checks
# --------------------------------------------------
# Liveness:
# "Is the application process alive?"
#
# Keep this check simple.
# Do NOT call the database, Frankfurter, or other services.
@app.route("/health/live", methods=["GET"])
def liveness():

    return jsonify({
        "status": "alive"
    })


# Readiness:
# "Can this service currently serve requests?"
#
# Check the dependency that is required to serve
# the /rates endpoint.
@app.route("/health/ready", methods=["GET"])
def readiness():

    try:
        response = requests.get(
            FRANKFURTER_URL,
            params={
                "base": "EUR",
                "quotes": "USD"
            },
            timeout=2
        )

        response.raise_for_status()

        return jsonify({
            "status": "ready"
        }), 200

    except requests.RequestException:

        return jsonify({
            "status": "not_ready"
        }), 503


# --------------------------------------------------
# Application startup
# --------------------------------------------------
if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5050
    )