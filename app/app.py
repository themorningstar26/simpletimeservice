from flask import Flask, request, jsonify
import datetime
import os
app = Flask(__name__)
@app.route('/', methods=['GET'])  # This would cause 405 for GET requests
def get_time_and_ip():
    # Get current timestamp
    current_time = datetime.datetime.now().isoformat()

    # Get visitor IP address
    # Check for forwarded IP first (for load balancers)
    visitor_ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    if visitor_ip:
        visitor_ip = visitor_ip.split(',')[0].strip()

    response = {
        "timestamp": current_time,
        "ip": visitor_ip
    }

    return jsonify(response)
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)