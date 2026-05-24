export default async function handler(req, res) {
  // Only allow POST requests
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { prompt, system } = req.body;
  const apiKey = process.env.CLAUDE_API_KEY;

  if (!apiKey) {
    return res.status(500).json({ 
      error: 'Claude API key not configured on server. Contact admin.' 
    });
  }

  try {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01'
      },
      body: JSON.stringify({
        model: 'claude-sonnet-4-6',
        max_tokens: 1000,
        system: system || 'You are a helpful assistant.',
        messages: [{ 
          role: 'user', 
          content: prompt 
        }]
      })
    });

    const data = await response.json();

    if (!response.ok) {
      console.error('Claude API error:', data);
      return res.status(response.status).json({ 
        error: data.error?.message || 'Claude API error',
        details: data
      });
    }

    res.status(200).json({
      success: true,
      text: data.content[0]?.text || ''
    });

  } catch (error) {
    console.error('Handler error:', error);
    res.status(500).json({ 
      error: error.message,
      type: 'fetch_error'
    });
  }
}
