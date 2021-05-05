# locust

```
token_string = "token string"

resp = self.client.post(
            url="http://someserver",
            data=json.dumps(data),
            auth=None,
            headers={"authorization": "Token " + token_string},
            name="http://someserver",
        )
```
