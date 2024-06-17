import http from 'k6/http';
import { sleep } from 'k6';

// http://petstoreproductservice-eastus.azurewebsites.net/swagger-ui/index.html

export default function () {
    http.get('https://petstoreproductservice-eastus.azurewebsites.net/petstoreproductservice/v2/product/info');
    sleep(1); // Adjust the sleep time as needed
}
