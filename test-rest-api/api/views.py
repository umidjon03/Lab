from django.http import HttpResponse

def api_data(request):
    xml_response = """<?xml version="1.0" encoding="UTF-8"?>
        <response>
            <status>200</status>
            <message>OK</message>
            <data>
                <user>
                    <id>123</id>
                    <name>John Doe</name>
                    <email>john.doe@example.com</email>
                </user>
                <products>
                    <product>
                        <id>987</id>
                        <name>Widget A</name>
                        <price>19.99</price>
                    </product>
                    <product>
                        <id>654</id>
                        <name>Gadget B</name>
                        <price>39.99</price>
                    </product>
                </products>
            </data>
        </response>
    """
    return HttpResponse(xml_response, content_type='application/xml')
